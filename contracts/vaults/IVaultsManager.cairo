// SPDX-License-Identifier: MIT
%lang starknet

using address = felt

@contract_interface
namespace IVaultsManager {
    func createVault(tokens: address*, tokens_len: felt, amounts: felt*, amounts_len: felt, zusd_to_mint: Uint256) {
    }

}
