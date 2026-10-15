BITS 64
global pci_init
global pci_read32

pci_init:
    ret

pci_read32:
    xor eax, eax
    ret
