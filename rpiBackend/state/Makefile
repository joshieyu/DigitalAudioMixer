TARGET = armv7-unknown-linux-gnueabihf
PI_USER = pi
PI_HOST = raspberrypi.local
PI_DIR = /home/pi/your_project

.PHONY: build sync compile

build:
    cross build --target $(TARGET) --release

sync:
    rsync -avz --delete --exclude 'target' --exclude '.git' . $(PI_USER)@$(PI_HOST):$(PI_DIR)

compile:
    ssh $(PI_USER)@$(PI_HOST) 'cd $(PI_DIR) && cargo build --release'

deploy: sync compile

transfer:
    scp -r src Cargo.toml admin@raspberrypi.local:~/state_manager