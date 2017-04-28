####################################################################
#
# When being in either FE or BE directory, switch into each repo
# respectively and pull + rebase from devex' develop branch with.
#
####################################################################

(cd ../grape-api && git pull --rebase devex develop && cd ../front-end && git pull --rebase devex develop)
