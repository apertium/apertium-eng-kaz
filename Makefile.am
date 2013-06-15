###############################################################################
## Makefile for eng-kaz
###############################################################################

VERSION=0.1.0
LANG1=eng
LANG2=kaz
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = $(PREFIX1).autobil.bin $(PREFIX2).autobil.bin \
	$(PREFIX1).automorf.bin $(PREFIX1).autogen.bin $(PREFIX1).t1x.bin  \
	$(PREFIX2).automorf.hfst $(PREFIX2).autogen.hfst $(PREFIX2).t1x.bin  \
        $(PREFIX1).t2x.bin $(PREFIX1).t3x.bin \
        $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin \
	$(PREFIX1).t4x.bin \
        $(PREFIX1).rlx.bin $(PREFIX2).rlx.bin \
        $(PREFIX1).lrx.bin $(PREFIX2).lrx.bin \
	$(PREFIX1).mode $(PREFIX2).mode modes 

###############################################################################
## eng transducer
###############################################################################

$(PREFIX2).autogen.bin:  $(BASENAME).$(LANG1).dix
	lt-comp rl $< $@

$(PREFIX1).automorf.bin: $(BASENAME).$(LANG1).dix
	lt-comp lr $< $@

###############################################################################
## kaz transducer
###############################################################################

.deps/$(LANG2).twol.hfst: $(BASENAME).$(LANG2).twol
	if [ ! -d .deps ]; then mkdir .deps; fi
	hfst-twolc $< -o $@
 
.deps/$(LANG2).RL.lexc: $(BASENAME).$(LANG2).lexc
	if [ ! -d .deps ]; then mkdir .deps; fi
	cat $< | grep -v 'Dir/LR' > $@
 
.deps/$(LANG2).LR.lexc: $(BASENAME).$(LANG2).lexc
	if [ ! -d .deps ]; then mkdir .deps; fi
	cat $< | grep -v 'Dir/RL' > $@

.deps/$(LANG2).RL.lexc.hfst: .deps/$(LANG2).RL.lexc
	hfst-lexc --format foma $< -o $@

.deps/$(LANG2).LR.lexc.hfst: .deps/$(LANG2).LR.lexc
	hfst-lexc --format foma $< -o $@

.deps/$(LANG2).RL.hfst: .deps/$(LANG2).RL.lexc.hfst .deps/$(LANG2).twol.hfst
	hfst-compose-intersect -1 .deps/$(LANG2).RL.lexc.hfst -2 .deps/$(LANG2).twol.hfst -o $@

.deps/$(LANG2).LR.hfst: .deps/$(LANG2).LR.lexc.hfst .deps/$(LANG2).twol.hfst
	hfst-compose-intersect -1 .deps/$(LANG2).LR.lexc.hfst -2 .deps/$(LANG2).twol.hfst -o $@

$(PREFIX1).autogen.hfst: .deps/$(LANG2).RL.hfst
	hfst-fst2fst -O $< -o $@

$(PREFIX2).automorf.hfst: .deps/$(LANG2).LR.hfst
	hfst-invert $< | hfst-fst2fst -O -o $@

###############################################################################
## Debugging transducers (for testvoc)
###############################################################################

.deps/$(LANG2).LR-debug.hfst: $(BASENAME).$(LANG2).lexc
	if [ ! -d .deps ]; then mkdir .deps; fi
	cat $< | grep -v 'Dir/RL' | grep -v 'Use/Circ' > .deps/$(LANG2).LR-debug.lexc
	hfst-lexc --format foma .deps/$(LANG2).LR-debug.lexc -o .deps/$(LANG2).LR-debug.lexc.hfst
	hfst-compose-intersect -1 .deps/$(LANG2).LR-debug.lexc.hfst -2 .deps/$(LANG2).twol.hfst -o $@

###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $< 
	lt-comp rl $< $@

###############################################################################
## Disambiguation rules 
###############################################################################

$(PREFIX1).rlx.bin: $(BASENAME).$(PREFIX1).rlx
	cg-comp $< $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx
	cg-comp $< $@


###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).lrx.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

$(PREFIX2).lrx.bin: $(BASENAME).$(PREFIX2).lrx
	lrx-comp $< $@

###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX1).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t2x $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX1).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t3x $@

$(PREFIX1).t4x.bin: $(BASENAME).$(PREFIX1).t4x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t4x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t4x $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX2).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t2x $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX2).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t3x $@


###############################################################################
## Postgeneration dictionaries
###############################################################################

#$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
#	apertium-validate-dictionary $<
#	lt-comp lr $< $@
#
#$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG2).dix
#	apertium-validate-dictionary $< 
#	lt-comp lr $< $@

###############################################################################
## Translation modes
###############################################################################

modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

modes/$(PREFIX2).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

###############################################################################
## Installation stuff
###############################################################################

debug: .deps/$(LANG1).LR-debug.hfst .deps/$(LANG2).LR-debug.hfst

EXTRA_DIST=$(PREFIX1).prob $(PREFIX2).prob \
           $(BASENAME).$(PREFIX1).t1x $(BASENAME).$(PREFIX1).t2x $(BASENAME).$(PREFIX1).t3x \
	   $(BASENAME).$(PREFIX1).t4x \
	   $(BASENAME).$(PREFIX2).t1x $(BASENAME).$(PREFIX2).t2x $(BASENAME).$(PREFIX2).t3x \
           modes.xml

apertium_eng_kazmodesdir=$(prefix)/share/apertium/modes/
apertium_eng_kazdir=$(prefix)/share/apertium/$(BASENAME)/

apertium_eng_kaz_DATA=$(PREFIX1).autobil.bin $(PREFIX2).autobil.bin \
                    $(PREFIX1).prob $(PREFIX2).prob \
		    $(PREFIX1).autogen.hfst $(PREFIX2).autogen.bin \
		    $(PREFIX1).automorf.bin $(PREFIX2).automorf.hfst \
		    $(PREFIX1).t1x.bin $(PREFIX2).t1x.bin \
		    $(PREFIX1).t2x.bin $(PREFIX2).t2x.bin \
		    $(PREFIX1).t3x.bin $(PREFIX2).t3x.bin \
		    $(PREFIX1).t4x.bin \ # hack to remove PXD and ND
		    $(PREFIX1).rlx.bin $(PREFIX2).rlx.bin \
		    $(PREFIX1).lrx.bin $(PREFIX2).lrx.bin \
		    $(BASENAME).$(PREFIX1).t1x $(BASENAME).$(PREFIX2).t1x \
		    modes.xml

#		    $(PREFIX1).autopgen.bin $(PREFIX2).autopgen.bin 

noinst_DATA=modes/$(PREFIX1).mode modes/$(PREFIX2).mode


install-data-local:
	mv modes modes~
	$(prefix)/bin/apertium-gen-modes modes.xml $(BASENAME)
	rm -rf modes
	mv modes~ modes
	test -d $(DESTDIR)$(apertium_eng_kazmodesdir) || mkdir $(DESTDIR)$(apertium_eng_kazmodesdir)
	$(INSTALL_DATA) $(PREFIX1).mode $(DESTDIR)$(apertium_eng_kazmodesdir)
	rm $(PREFIX1).mode
	rm $(PREFIX2).mode
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_eng_kazdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(DESTDIR)$(apertium_eng_kazdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t2x $(DESTDIR)$(apertium_eng_kazdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t2x $(DESTDIR)$(apertium_eng_kazdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t3x $(DESTDIR)$(apertium_eng_kazdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t3x $(DESTDIR)$(apertium_eng_kazdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t4x $(DESTDIR)$(apertium_eng_kazdir)

CLEANFILES = -r $(TARGETS_COMMON) .deps/
