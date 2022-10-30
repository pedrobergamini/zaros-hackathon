// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.bool import TRUE
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from contracts.vaults.IVaultsManager import Vault
from contracts.vaults.library import VaultsManager

using address = felt;
using bool = felt;

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(zaros: address) {
    VaultsManager.initializer(zaros);

    return ();
}

@view
func readVault{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(user: address) -> (
    res: Vault
) {
    let (res: Vault) = VaultsManager.read_vault(user);

    return (res,);
}

@external
func createVault{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    eth_amount: Uint256, dai_amount: Uint256, usdc_amount: Uint256, zusd_to_mint: Uint256
) -> (success: bool) {
    VaultsManager.create_vault(eth_amount, dai_amount, usdc_amount, zusd_to_mint);

    return (TRUE,);
}
