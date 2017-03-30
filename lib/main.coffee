SymbolsTreeViewFix = require './symbols-tree-view-fix'

module.exports =
  config:
    autoToggle:
      type: 'boolean'
      default: false
      description: 'If this option is enabled then symbols-tree-view-fix will auto open when you open files.'
    scrollAnimation:
      type: 'boolean'
      default: true
      description: 'If this option is enabled then when you click the item in symbols-tree it will scroll to the destination gradually.'
    autoHide:
      type: 'boolean'
      default: false
      description: 'If this option is enabled then symbols-tree-view-fix is always hidden unless mouse hover over it.'
    zAutoHideTypes:
      title: 'AutoHideTypes'
      type: 'string'
      description: 'Here you can specify a list of types that will be hidden by default (ex: "variable class")'
      default: ''
    sortByNameScopes:
      type: 'string'
      description: 'Here you can specify a list of scopes that will be sorted by name (ex: "text.html.php")'
      default: ''
    defaultWidth:
      type: 'number'
      description: 'Width of the panel (needs Atom restart)'
      default: 200


  symbolsTreeViewFix: null

  activate: (state) ->
    @symbolsTreeViewFix = new SymbolsTreeViewFix(state.symbolsTreeViewFixState)
    atom.commands.add 'atom-workspace', 'symbols-tree-view-fix:toggle': => @symbolsTreeViewFix.toggle()
    atom.commands.add 'atom-workspace', 'symbols-tree-view-fix:show': => @symbolsTreeViewFix.showView()
    atom.commands.add 'atom-workspace', 'symbols-tree-view-fix:hide': => @symbolsTreeViewFix.hideView()

    atom.config.observe 'tree-view.showOnRightSide', (value) =>
      if @symbolsTreeViewFix.hasParent()
        @symbolsTreeViewFix.remove()
        @symbolsTreeViewFix.populate()
        @symbolsTreeViewFix.attach()

    atom.config.observe "symbols-tree-view-fix.autoToggle", (enabled) =>
      if enabled
        @symbolsTreeViewFix.toggle() unless @symbolsTreeViewFix.hasParent()
      else
        @symbolsTreeViewFix.toggle() if @symbolsTreeViewFix.hasParent()

  deactivate: ->
    @symbolsTreeViewFix.destroy()

  serialize: ->
    symbolsTreeViewFixState: @symbolsTreeViewFix.serialize()

  getProvider: ->
    view = @symbolsTreeViewFix

    providerName: 'symbols-tree-view-fix'
    getSuggestionForWord: (textEditor, text, range) =>
      range: range
      callback: ()=>
        view.focusClickedTag.bind(view)(textEditor, text)
