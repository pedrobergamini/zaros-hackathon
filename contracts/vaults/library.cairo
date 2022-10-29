// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.uint256 import Uint256
from contracts.vaults.IVaultsManager import Vault

using address = felt;

// @dev Static collateralization ratio. Definitely not for production lol
const C_RATIO = 3 * 10 ** 18;

@storage_var
func VaultsManager_vaults(user: address) -> (res: Vault) {
}

namespace VaultsManager {
    func create_vault{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        tokens: address*,
        tokens_len: felt,
        amounts: Uint256*,
        amounts_len: felt,
        zusd_to_mint: Uint256,
    ) {
        alloc_locals;
        _verify_caller();
    }

    func _verify_caller(caller: address) {
        with_attr error_message("Zaros: caller is address 0") {
            assert_not_zero(caller);
        }

        return ();
    }
}
