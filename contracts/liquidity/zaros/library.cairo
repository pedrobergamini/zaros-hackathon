// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.uint256 import Uint256
from openzeppelin.token.erc20.library import ERC20

namespace Zaros {
    // Storage vars
    @storage_var
    func Zaros_debt_total_supply() -> (res: Uint256) {
    }

    @storage_var
    func Zaros_accumulated_fees() -> (res: Uint256) {
    }

    @storage_var
    func Zaros_spot_exchange() -> (res: felt) {
    }

    @storage_var
    func Zaros_debt_shares(user: felt) -> (res: Uint256) {
    }

    // Read functions

    func debt_total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: Uint256
    ) {
    }

    func accumulated_fees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: Uint256
    ) {
    }

    func protocol_debt_usd{syscall_ptr: felt, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: Uint256
    ) {
    }

    func spot_exchange{syscall_ptr: felt, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: felt
    ) {
    }

    func debt_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: Uint256
    ) -> (res: felt) {
    }

    // Write functions

    // only registered exchanges
    func mint_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        amount: Uint256
    ) {
    }

    // only registered exchanges
    func burn_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        amount: Uint256
    ) {
    }

    // only registered exchanges
    func update_fees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(fee: Uint256) {
    }
}
