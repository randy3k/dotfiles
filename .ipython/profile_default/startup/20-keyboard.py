import IPython

try:
    if IPython.__version__ > "6":
        ip = IPython.get_ipython()
        registry = ip.pt_cli.application.key_bindings_registry

        handler = next(kb.handler for kb in registry.key_bindings if kb.handler.__name__ == "newline_autoindent")
        registry.remove_binding(handler)
except:
    pass
