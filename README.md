# Download a http site

## 1. list.pl

```bash
perl list.pl -u http://mus.well.ox.ac.uk/19genomes/fasta/
```

Screen outputs.

```
URL checker opt:
--- !!perl/hash:Urlcheck
dir_to_mk: {}
local_base: 19genomes/fasta
not_check_parent: 0
remote_base: /19genomes/fasta/
site: mus.well.ox.ac.uk
url_bad: {}
url_path: {}
verbose: 1

URL: http://mus.well.ox.ac.uk/19genomes/fasta/

WORKING DIR: .

* . ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/?C=N;O=D
* .?C=N;O=D ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/?C=M;O=A
* .?C=M;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/?C=S;O=A
* .?C=S;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/?C=D;O=A
* .?C=D;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/
* MASKED ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/?C=N;O=D
* MASKED?C=N;O=D ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/?C=M;O=A
* MASKED?C=M;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/?C=S;O=A
* MASKED?C=S;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/?C=D;O=A
* MASKED?C=D;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/README
* MASKED/README ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/bur_0.v7.PR_in_lowercase.fas
* MASKED/bur_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/can_0.v7.PR_in_lowercase.fas
* MASKED/can_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/ct_1.v7.PR_in_lowercase.fas
* MASKED/ct_1.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/edi_0.v7.PR_in_lowercase.fas
* MASKED/edi_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/hi_0.v7.PR_in_lowercase.fas
* MASKED/hi_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/kn_0.v7.PR_in_lowercase.fas
* MASKED/kn_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/ler_0.v7.PR_in_lowercase.fas
* MASKED/ler_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/mt_0.v7.PR_in_lowercase.fas
* MASKED/mt_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/no_0.v7.PR_in_lowercase.fas
* MASKED/no_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/oy_0.v7.PR_in_lowercase.fas
* MASKED/oy_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/po_0.v7.PR_in_lowercase.fas
* MASKED/po_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/rsch_4.v7.PR_in_lowercase.fas
* MASKED/rsch_4.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/sf_2.v7.PR_in_lowercase.fas
* MASKED/sf_2.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/tsu_0.v7.PR_in_lowercase.fas
* MASKED/tsu_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/wil_2.v7.PR_in_lowercase.fas
* MASKED/wil_2.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/ws_0.v7.PR_in_lowercase.fas
* MASKED/ws_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/wu_0.v7.PR_in_lowercase.fas
* MASKED/wu_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/MASKED/zu_0.v7.PR_in_lowercase.fas
* MASKED/zu_0.v7.PR_in_lowercase.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/
* UNMASKED ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/?C=N;O=D
* UNMASKED?C=N;O=D ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/?C=M;O=A
* UNMASKED?C=M;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/?C=S;O=A
* UNMASKED?C=S;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/?C=D;O=A
* UNMASKED?C=D;O=A ==> [BAD]
check_clean failed
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/bur_0.v7.fas
* UNMASKED/bur_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/can_0.v7.fas
* UNMASKED/can_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/ct_1.v7.fas
* UNMASKED/ct_1.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/edi_0.v7.fas
* UNMASKED/edi_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/hi_0.v7.fas
* UNMASKED/hi_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/kn_0.v7.fas
* UNMASKED/kn_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/ler_0.v7.fas
* UNMASKED/ler_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/mt_0.v7.fas
* UNMASKED/mt_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/no_0.v7.fas
* UNMASKED/no_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/oy_0.v7.fas
* UNMASKED/oy_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/po_0.v7.fas
* UNMASKED/po_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/rsch_4.v7.fas
* UNMASKED/rsch_4.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/sf_2.v7.fas
* UNMASKED/sf_2.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/tsu_0.v7.fas
* UNMASKED/tsu_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/wil_2.v7.fas
* UNMASKED/wil_2.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/ws_0.v7.fas
* UNMASKED/ws_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/wu_0.v7.fas
* UNMASKED/wu_0.v7.fas ==> [ADD]
http://mus.well.ox.ac.uk/19genomes/fasta/UNMASKED/zu_0.v7.fas
* UNMASKED/zu_0.v7.fas ==> [ADD]
```

## 2. download.pl

```bash
perl download.pl -i 19genomes_fasta.yml
```
