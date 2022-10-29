// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.uint256 import Uint256

using address = felt;
using bool = felt;

struct Vault {
    tokens: address*,
    tokens_len: felt,
    amounts: Uint256*,
    amounts_len: felt,
    debt: Uint256,
}

@contract_interface
namespace IVaultsManager {
    func createVault(
        tokens: address*, tokens_len: felt, amounts: felt*, amounts_len: felt, zusd_to_mint: Uint256
    ) -> (success: bool) {
    }
}
