from IPython import get_ipython


ip = get_ipython()
registry = ip.pt_cli.application.key_bindings_registry

handler = next(kb.handler for kb in registry.key_bindings if kb.handler.__name__ == "newline_autoindent")
registry.remove_binding(handler)
