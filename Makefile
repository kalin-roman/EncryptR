# Copyright (C) 2017 Daniel Page <csdsp@bristol.ac.uk>
#
# Use of this source code is restricted per the CC BY-NC-ND license, a copy of 
# which can be found via http://creativecommons.org (and should be included as 
# LICENSE.txt within the associated archive or repository).

# =============================================================================

ARCHIVE      = solution.tar.gz

TARGETS_VVP  = 
TARGETS_VCD  = 

define rules
$(strip ${1}).sizer      : $$(addsuffix .v,${2})
	@iverilog -Wall -tsizer -S -s ${1}      -o $${@} $${^}
$(strip ${1})_test.sizer : $$(addsuffix .v,${2}) $(strip ${1})_test.v
	@iverilog -Wall -tsizer -S -s ${1}_test -o $${@} $${^}

$(strip ${1}).vvp        : $$(addsuffix .v,${2})
	@iverilog -Wall -g2012     -s ${1}      -o $${@} $${^}
$(strip ${1})_test.vvp   : $$(addsuffix .v,${2}) $(strip ${1})_test.v
	@iverilog -Wall -g2012     -s ${1}_test -o $${@} $${^}

$(strip ${1})_test.vcd   :                       $(strip ${1})_test.vvp .FORCE
	@vvp $${<} $${ARGS}

TARGETS_VVP += ${1}_test.vvp
TARGETS_VCD += ${1}_test.vcd
endef

# -----------------------------------------------------------------------------

.FORCE     :

${ARCHIVE} :
	@tar --create --gzip --transform='s|^|solution/|' --file ${@} *

$(eval $(call rules,     clr_28bit, util                                 clr_28bit))
$(eval $(call rules,  key_schedule, util                    key_schedule clr_28bit))
$(eval $(call rules,         round, util              round                       ))
$(eval $(call rules,  encrypt_comb, util encrypt_comb round key_schedule clr_28bit))
$(eval $(call rules,  encrypt_iter, util encrypt_iter round key_schedule clr_28bit))
$(eval $(call rules,  encrypt_pipe, util encrypt_pipe round key_schedule clr_28bit))

# -----------------------------------------------------------------------------

all      :          ${TARGETS_VVP}

clean    :
	@rm --force ${TARGETS_VVP} ${TARGETS_VCD} ${ARCHIVE}

spotless : clean
	@rm --force *.sizer
	@rm --force *.vvp
	@rm --force *.vcd

# =============================================================================
