PICO8   := ~/pico-8/pico8
FLAGS   := -windowed 1 -root_path $(shell pwd)
CART    := pico-signals

all:	build

build:	build_cart

build_cart:	clean
	$(PICO8) $(CART) -export $(CART).p8.png

run:	build_cart
	$(PICO8) $(FLAGS) -run $(CART)

clean:
	@rm -f $(CART).p8.png

pico8:
	$(PICO8)