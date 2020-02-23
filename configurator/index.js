let disable_tree_event = false

$('#tree').jstree({
	core : {
		data : effects_tree
	},
	checkbox: {
		tie_selection: false
	},
	types : {
      effect : {
        icon : false
      }
    },
	plugins: ["checkbox", "types"]
});

$('#tree').on('ready.jstree', () => {
	let tree = $.jstree.reference('#tree')
	tree.get_json(undefined,{flat:true})
		.map(n => tree.get_node(n.id))
		.filter(n => n.children.length == 0)
		.forEach(n => tree.set_icon(n, false))
})

$('#tree').on('ready.jstree check_node.jstree uncheck_node.jstree', () => {
	if (disable_tree_event) {
		return
	}
	let tree = $.jstree.reference('#tree')
	let effects = tree.get_checked()
					.map(id => tree.get_node(id).original)
					.filter(orig => orig.start !== undefined)
					.reduce((obj, item) => {
						item_copy = JSON.parse(JSON.stringify(item))
						delete item_copy.text
						obj[item.text] = item_copy
						return obj
					}, {})
	effects = {"effects": effects}
	effects = VDF.stringify(effects)
	
	$('#input').val(effects)
	$('#input').removeClass('error')
})

$("#input").on('input', (event) => {
	let effects
	try {
		effects = VDF.parse(event.target.value)
	}
	catch (ex) {
		if (!(ex instanceof SyntaxError)) {
			throw ex
		}
	}
	if (effects === undefined ||
			effects.effects === undefined) {
		$(event.target).addClass('error')
		return
	}
	
	effects = effects.effects
	
	let tree = $.jstree.reference('#tree')
	disable_tree_event = true
	tree.uncheck_all()
	tree.get_json(undefined,{flat:true})
		.filter(n => effects[n.text] !== undefined)
		.map(n => tree.get_node(n.id))
		.forEach(n => {
			tree.check_node(n.id)
			Object.assign(n.original, effects[n.text])
		})
	disable_tree_event = false
	
	$(event.target).removeClass('error')
})