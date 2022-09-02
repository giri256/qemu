    qemu_hd_replacement="WD5000AAKS-40V28O"
    qemu_dvd_replacement="OPTIARC DVD RW AD-5680H"
    hypervisor_string_replacement="GenuineIntel"
    bochs_cpu_replacement="INTELCPU"
    qemu_bochs_cpu='INTEL\/INTEL'
    qemu_space_replacement="intel "
    src_misc_bios_table="07\/02\/18"
    src_bios_table_date2="11\/03\/2018"
    src_fw_smbios_date="11\/03\/2018"
    sed -i "s/QEMU HARDDISK/$qemu_hd_replacement/g" hw/ide/core.c
    sed -i "s/QEMU HARDDISK/$qemu_hd_replacement/g" hw/scsi/scsi-disk.c
    sed -i "s/QEMU DVD-ROM/$qemu_dvd_replacement/g" hw/ide/core.c
    sed -i "s/QEMU DVD-ROM/$qemu_dvd_replacement/g" hw/ide/atapi.c
    sed -i "s/QEMU PenPartner tablet/CR32 PenPartner tablet/g" hw/usb/dev-wacom.c
    sed -i 's/s->vendor = g_strdup("QEMU");/s->vendor = g_strdup("CR32");/g' hw/scsi/scsi-disk.c
    sed -i "s/QEMU CD-ROM/$qemu_dvd_replacement/g" hw/scsi/scsi-disk.c
    sed -i 's/padstr8(buf + 8, 8, "QEMU");/padstr8(buf + 8, 8, "CR32");/g' hw/ide/atapi.c
    sed -i 's/QEMU MICRODRIVE/CR32 MICRODRIVE/g' hw/ide/core.c
    sed -i "s/VS#1\0\0\0\0\0\0\0\0/$hypervisor_string_replacement/g" target/i386/kvm/kvm.c
    sed -i 's/"bochs"/"CR32"/g' block/bochs.c
    sed -i 's/"BOCHS "/"ALASKA"/g' include/hw/acpi/aml-build.h
    sed -i 's/Microsoft VS/$hypervisor_string_replacement/g' target/i386/kvm/kvm.c
