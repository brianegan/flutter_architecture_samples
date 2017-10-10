.PHONY: clean localize all check_env

FILES := $(shell find . -name '*.arb' | xargs)

all: localize

localize: check_env clean
	pub run intl_translation:extract_to_arb --output-dir=./ --no-transformer lib/src/localization.dart
	mv intl_messages.arb intl_en.arb
	pub run intl_translation:generate_from_arb lib/src/localization.dart $(FILES)
	mv messages*.dart lib/src/localizations

clean:
	rm -f *.arb

check_env:
ifndef FLUTTER_ROOT
	$(error FLUTTER_ROOT is undefined. Please export a FLUTTER_ROOT pointing to the installation of Flutter.)
endif