# valign

Example mapping:

    let g:Valign_PadChar = "-"
    vnoremap gi <esc>:call foo#Align()<CR>


Before:

    ... CGATCTGACTTGCGACGTACGTAGCACGAT  ...
    ... ATCTGACTTGCGACGTACGTAGCACGATCG  ...
    ... CTGACTTGCGACGTACGTAGCACGATCGAT  ...
    ... GACTTGCGACGTACGTAGCACGATCGATGC  ...


Search for a common "anchor" sequence, for example, `/\vGC..CG`.

Then, block-select the sequences with `<C-V>`. For example, place the cursor at the top left "C". Then, `v` `i` `w` `CTRL-v` `j` `j` `j`

Finaly, trigger the aligner with `gi`.

After:

    ... CGATCTGACTTGCGACGTACGTAGCACGAT------  ...
    ... --ATCTGACTTGCGACGTACGTAGCACGATCG----  ...
    ... ----CTGACTTGCGACGTACGTAGCACGATCGAT--  ...
    ... ------GACTTGCGACGTACGTAGCACGATCGATGC  ...


# Testing

Testing uses the `vim-vspec` framework.

    # Clone vim-vspec
    git clone git@github.com:kana/vim-vspec.git
    cd vim-vspect
    git checkout master  # make sure you're on master
    cd ..

    # Clone vim-valign
    git clone git@github.com:gshiba/vim-valign.git
    cd vim_valign

    # Run tests
    ../vim-vspec/bin/prove-vspec -d .
