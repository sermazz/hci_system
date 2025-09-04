# Copyright 2025 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE.solderpad for details.
# SPDX-License-Identifier: SHL-0.51
#
# Sergio Mazzola <smazzola@iis.ee.ethz.ch>

log -r /*

if {$GUI == 1} {
    add wave -noupdate /tb_hci_system/s_clk
    add wave -noupdate /tb_hci_system/s_rst_n

    add wave -noupdate -group params /hci_system_pkg/N_HWPE
    add wave -noupdate -group params /hci_system_pkg/N_CORE
    add wave -noupdate -group params /hci_system_pkg/HWPE_WIDTH_FACT
    add wave -noupdate -group params /hci_system_pkg/N_BANKS
    add wave -noupdate -group params /hci_system_pkg/BANK_SIZE
    add wave -noupdate -group params /hci_system_pkg/USE_HCI
    add wave -noupdate -group params /hci_system_pkg/SEL_LIC
    add wave -noupdate -group params /hci_system_pkg/N_DMA
    add wave -noupdate -group params /hci_system_pkg/N_EXT
    add wave -noupdate -group params /hci_system_pkg/ID_PERIPH
    add wave -noupdate -group params /hci_system_pkg/MAX_N_DATAMOVERS
    add wave -noupdate -group params /hci_system_pkg/TS_BIT
    add wave -noupdate -group params /hci_system_pkg/EXPFIFO
    add wave -noupdate -group params /hci_system_pkg/IW
    add wave -noupdate -group params /hci_system_pkg/TCDM_SIZE
    add wave -noupdate -group params /hci_system_pkg/N_DATAMOVERS
    add wave -noupdate -group params /hci_system_pkg/DW_cores
    add wave -noupdate -group params /hci_system_pkg/AW_cores
    add wave -noupdate -group params /hci_system_pkg/BW_cores
    add wave -noupdate -group params /hci_system_pkg/UW_cores
    add wave -noupdate -group params /hci_system_pkg/IW_cores
    add wave -noupdate -group params /hci_system_pkg/EW_cores
    add wave -noupdate -group params /hci_system_pkg/EHW_cores
    add wave -noupdate -group params /hci_system_pkg/DW_hwpe
    add wave -noupdate -group params /hci_system_pkg/AW_hwpe
    add wave -noupdate -group params /hci_system_pkg/BW_hwpe
    add wave -noupdate -group params /hci_system_pkg/UW_hwpe
    add wave -noupdate -group params /hci_system_pkg/IW_hwpe
    add wave -noupdate -group params /hci_system_pkg/EW_hwpe
    add wave -noupdate -group params /hci_system_pkg/EHW_hwpe
    add wave -noupdate -group params /hci_system_pkg/DW_mems
    add wave -noupdate -group params /hci_system_pkg/AW_mems
    add wave -noupdate -group params /hci_system_pkg/BW_mems
    add wave -noupdate -group params /hci_system_pkg/UW_mems
    add wave -noupdate -group params /hci_system_pkg/IW_mems
    add wave -noupdate -group params /hci_system_pkg/EW_mems
    add wave -noupdate -group params /hci_system_pkg/EHW_mems

    add wave -noupdate -group hci_system -group params /tb_hci_system/i_dut/WAIVE_RQ3_ASSERT
    add wave -noupdate -group hci_system -group params /tb_hci_system/i_dut/WAIVE_RQ4_ASSERT
    add wave -noupdate -group hci_system -group params /tb_hci_system/i_dut/WAIVE_RSP3_ASSERT
    add wave -noupdate -group hci_system -group params /tb_hci_system/i_dut/WAIVE_RSP5_ASSERT
    add wave -noupdate -group hci_system -group params /tb_hci_system/i_dut/HCI_SIZE_cores
    add wave -noupdate -group hci_system -group params /tb_hci_system/i_dut/HCI_SIZE_mems
    add wave -noupdate -group hci_system -group params /tb_hci_system/i_dut/HCI_SIZE_hwpe
    add wave -noupdate -group hci_system -group params /tb_hci_system/i_dut/N_WORDS

    add wave -noupdate -group hci_system /tb_hci_system/i_dut/clk_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/rst_ni
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/clear_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/arb_policy_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/invert_prio_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/low_prio_max_stall_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_req_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_gnt_o
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_add_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_wen_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_be_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_data_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_id_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_r_data_o
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_r_valid_o
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/periph_r_id_o
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_req_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_gnt_o
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_add_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_wen_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_data_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_be_i
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_r_data_o
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_r_valid_o
    add wave -noupdate -group hci_system /tb_hci_system/i_dut/ext_tcdm_r_ready_i

    for {set i 0} {$i < [examine -radix dec /hci_system_pkg/N_BANKS]} {incr i} {
        add wave -noupdate -group tcdm_banks -label bank_$i /tb_hci_system/i_dut/i_tcdm/gen_banks[$i]/i_bank/sram
    }

    for {set i 0} {$i < [examine -radix dec /hci_system_pkg/N_CORE]} {incr i} {
        add wave -noupdate -group hci_initiator_core_if -group core_$i /tb_hci_system/i_dut/hci_initiator_core[$i]/*
    }
    for {set i 0} {$i < [examine -radix dec /hci_system_pkg/N_EXT]} {incr i} {
        add wave -noupdate -group hci_initiator_ext_if -group ext_$i /tb_hci_system/i_dut/hci_initiator_ext[$i]/*
    }
    for {set i 0} {$i < [examine -radix dec /hci_system_pkg/N_HWPE]} {incr i} {
        add wave -noupdate -group hci_initiator_hwpe_if -group hwpe_$i /tb_hci_system/i_dut/hci_initiator_hwpe[$i]/*
    }
    for {set i 0} {$i < [examine -radix dec /hci_system_pkg/N_BANKS]} {incr i} {
        add wave -noupdate -group hci_target_mems_if -group mems_$i /tb_hci_system/i_dut/hci_target_mems[$i]/*
    }
}
