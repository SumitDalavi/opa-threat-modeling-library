.PHONY: test demo

test:
	opa test policies/ -v

demo:
	./scripts/demo.sh
