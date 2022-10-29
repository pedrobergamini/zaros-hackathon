// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.uint256 import Uint256
from contracts.vaults.library import VaultsManager

using bool = felt;

@external
func createVault{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    tokens: address*, tokens_len: felt, amounts: Uint256*, amounts_len: felt, zusd_to_mint: Uint256
) -> (success: bool) {
    Zaros.create_vault(tokens, tokens_len, amounts, amounts_len, zusd_to_mint);

    return (TRUE,);
}
