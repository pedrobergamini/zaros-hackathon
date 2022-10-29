// SPDX-License-Identifier: MIT
%lang starknet

from contracts.oracle.eth.library import ETHOracle

@view
func quote{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eth_amount: Uint256
) -> (res: Uint256) {
    let (res: Uint256) = ETHOracle.quote(eth_amount);

    return (res,);
}
