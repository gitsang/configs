function! s:SetProtoALE()
    let g:ale_proto_protoc_gen_lint_options = '-I ./'
    let g:ale_proto_protoc_gen_lint_options .= '-I ../'
    let g:ale_proto_protoc_gen_lint_options .= '-I ../../'
    let g:ale_proto_protoc_gen_lint_options .= ' -I ../../third_party'
endfunction

autocmd BufRead,BufNewFile *.proto call s:SetProtoALE()
