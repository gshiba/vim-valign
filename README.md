# valign

Example mapping:

    let g:Foo_PadChar = "-"
    vnoremap gi <esc>:call foo#Align()<CR>


Before:

    ... CGATCTGACTTGCGACGTACGTAGCACGAT  ...
    ... ATCTGACTTGCGACGTACGTAGCACGATCG  ...
    ... CTGACTTGCGACGTACGTAGCACGATCGAT  ...
    ... GACTTGCGACGTACGTAGCACGATCGATGC  ...


Search for a common "anchor" sequence with `/\vGC..CG`.

Then, block-select the sequences with `<C-V>`. For example, place the cursor at the top left "C". Then, `v` `i` `w` `CTRL-v` `j` `j` `j`

Finaly, trigger the aligner with `gi`.

After:

    ... CGATCTGACTTGCGACGTACGTAGCACGAT------  ...
    ... --ATCTGACTTGCGACGTACGTAGCACGATCG----  ...
    ... ----CTGACTTGCGACGTACGTAGCACGATCGAT--  ...
    ... ------GACTTGCGACGTACGTAGCACGATCGATGC  ...


# Testing

Testing uses the `vim-vspec` framework.

    git clone vim-vspec
    git clone vim-valign
