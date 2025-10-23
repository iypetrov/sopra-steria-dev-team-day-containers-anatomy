ROOTFS := tinyroot
BUSYBOX := /bin/busybox
TARGET := $(ROOTFS)/bin/busybox

.PHONY: all clean prepare busybox setup-dev chroot

all: $(ROOTFS)

prepare:
	mkdir -p $(ROOTFS)/{bin,sbin,etc,proc,sys,dev,usr/bin,usr/sbin,tmp,root}
	chmod 1777 $(ROOTFS)/tmp

busybox: prepare
	cp $(BUSYBOX) $(TARGET)
	@echo "Creating BusyBox symlinks..."
	cd $(ROOTFS)/bin && for cmd in sh ls cp mv rm mkdir mount umount cat echo ps top ping; do \
		ln -sf busybox $$cmd; \
	done

setup-config: busybox
	@echo "Setting up /etc/passwd, /etc/group, /etc/resolv.conf..."
	echo "root:x:0:0:root:/root:/bin/sh" > $(ROOTFS)/etc/passwd
	echo "root:x:0:" > $(ROOTFS)/etc/group
	echo "nameserver 8.8.8.8" > $(ROOTFS)/etc/resolv.conf

setup-dev: setup-config
	@echo "Creating basic device nodes..."
	sudo mknod -m 666 $(ROOTFS)/dev/null c 1 3
	sudo mknod -m 666 $(ROOTFS)/dev/zero c 1 5
	sudo mknod -m 666 $(ROOTFS)/dev/tty c 5 0
	sudo mknod -m 666 $(ROOTFS)/dev/console c 5 1
	sudo mknod -m 666 $(ROOTFS)/dev/random c 1 8
	sudo mknod -m 666 $(ROOTFS)/dev/urandom c 1 9

$(ROOTFS): setup-dev
	@echo "Minimal root filesystem '$(ROOTFS)' is ready!"
	@echo "Use: sudo chroot $(ROOTFS) /bin/sh"

clean:
	@echo "Cleaning up..."
	sudo rm -rf $(ROOTFS)
