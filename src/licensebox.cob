       >>source format free
identification division.
program-id. LB-CREATE.
data division.
linkage section.
01 options-json pic x any length.
01 callbacks-pointer usage pointer.
01 client-handle usage pointer.
01 error-code pic x any length.
procedure division using options-json callbacks-pointer client-handle error-code.
    call static "lbc_create" using
        by reference options-json
        by value function length(options-json)
        by value callbacks-pointer
        by reference client-handle error-code
        by value function length(error-code)
        returning return-code
    goback.
end program LB-CREATE.

identification division.
program-id. LB-CALL.
data division.
linkage section.
01 client-handle usage pointer.
01 operation-name pic x any length.
01 args-json pic x any length.
01 result-json pic x any length.
01 error-code pic x any length.
procedure division using client-handle operation-name args-json result-json error-code.
    call static "lbc_call" using
        by value client-handle
        by reference operation-name
        by value function length(operation-name)
        by reference args-json
        by value function length(args-json)
        by reference result-json
        by value function length(result-json)
        by reference error-code
        by value function length(error-code)
        returning return-code
    goback.
end program LB-CALL.

identification division.
program-id. LB-CLOSE.
data division.
linkage section.
01 client-handle usage pointer.
procedure division using client-handle.
    call static "lbc_close" using by reference client-handle returning return-code
    goback.
end program LB-CLOSE.

identification division.
program-id. LB-DERIVE.
data division.
linkage section.
01 product-name pic x any length.
01 source-name pic x any length.
01 raw-id pic x any length.
01 binding-value pic x any length.
01 error-code pic x any length.
procedure division using product-name source-name raw-id binding-value error-code.
    call static "lbc_derive" using
        by reference product-name
        by value function length(product-name)
        by reference source-name
        by value function length(source-name)
        by reference raw-id
        by value function length(raw-id)
        by reference binding-value
        by value function length(binding-value)
        by reference error-code
        by value function length(error-code)
        returning return-code
    goback.
end program LB-DERIVE.

identification division.
program-id. LB-NATIVE.
data division.
linkage section.
01 product-name pic x any length.
01 binding-value pic x any length.
01 error-code pic x any length.
procedure division using product-name binding-value error-code.
    call static "lbc_native" using
        by reference product-name
        by value function length(product-name)
        by reference binding-value
        by value function length(binding-value)
        by reference error-code
        by value function length(error-code)
        returning return-code
    goback.
end program LB-NATIVE.

identification division.
program-id. LB-VERIFY.
data division.
linkage section.
01 token-value pic x any length.
01 product-name pic x any length.
01 keys-json pic x any length.
01 now-seconds usage float-long.
01 result-json pic x any length.
01 error-code pic x any length.
procedure division using token-value product-name keys-json now-seconds result-json error-code.
    call static "lbc_verify" using
        by reference token-value
        by value function length(token-value)
        by reference product-name
        by value function length(product-name)
        by reference keys-json
        by value function length(keys-json)
        by value now-seconds
        by reference result-json
        by value function length(result-json)
        by reference error-code
        by value function length(error-code)
        returning return-code
    goback.
end program LB-VERIFY.

identification division.
program-id. LB-HEARTBEAT.
data division.
linkage section.
01 client-handle usage pointer.
01 module-name pic x any length.
01 result-json pic x any length.
01 error-code pic x any length.
procedure division using client-handle module-name result-json error-code.
    call static "lbc_heartbeat" using
        by value client-handle
        by reference module-name
        by value function length(module-name)
        by reference result-json
        by value function length(result-json)
        by reference error-code
        by value function length(error-code)
        returning return-code
    goback.
end program LB-HEARTBEAT.
