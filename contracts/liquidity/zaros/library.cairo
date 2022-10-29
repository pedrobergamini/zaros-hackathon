// SPDX-License-Identifier: MIT
%lang starknet

from openzeppelin.token.erc20.library import ERC20

namespace Zaros {
    // Storage vars
    @storage_var
    func Zaros_debt_total_supply() -> (res: felt) {
    }

    @storage_var
    func Zaros_accumulated_fees() -> (res: felt) {
    }

    @storage_var
    func Zaros_debt_shares(user: felt) -> (res: felt) {
    }

    // Read functions

    func debt_total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: felt
    ) {
    }

    func accumulated_fees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: felt
    ) {
    }

    func protocol_debt_usd{syscall_ptr: felt, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: felt
    ) {
    }

    func debt_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: felt
    ) -> (res: felt) {
    }

    // Write functions

    // only registered exchanges
    func mint_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        amount: felt
    ) {
    }
}
