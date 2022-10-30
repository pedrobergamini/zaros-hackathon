// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.uint256 import Uint256

using address = felt;
using bool = felt;

struct Vault {
    eth_amount: Uint256,
    dai_amount: Uint256,
    usdc_amount: Uint256,
    debt: Uint256,
}

@contract_interface
namespace IVaultsManager {
    func createVault(
        eth_amount: Uint256, dai_amount: Uint256, usdc_amount: Uint256, zusd_to_mint: Uint256
    ) -> (success: bool) {
    }

    func readVault(user: address) -> (res: Vault) {
    }
}
