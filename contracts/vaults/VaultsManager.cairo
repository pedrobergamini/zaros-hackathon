// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from contracts.vaults.library import VaultsManager

using address = felt;
using bool = felt;

@external
func createVault{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eth_amount: Uint256, dai_amount: Uint256, usdc_amount: Uint256, zusd_to_mint: Uint256
) -> (success: bool) {
    VaultsManager.create_vault(eth_amount, dai_amount, usdc_amount, zusd_to_mint);

    return (TRUE,);
}
