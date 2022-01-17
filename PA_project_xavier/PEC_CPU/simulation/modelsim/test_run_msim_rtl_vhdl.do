transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/unidad_control.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/SRAMController.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/sisa.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/rellotge.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/regfile.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/proc.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/multi.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/MemoryController.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/driver4Displays.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/display7Segments.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/datapath.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/controladors_IO.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/control_l.vhd}
vcom -93 -work work {/home/mvidal/Dropbox/Labs/PA/git_workspace/project_sword/PEC_CPU/alu.vhd}

