// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.uint256 import Uint256
from openzeppelin.token.erc20.library import ERC20
from contracts.utils.constants.library import address

namespace Zaros {
    // Storage vars
    @storage_var
    func Zaros_accumulated_fees() -> (res: Uint256) {
    }

    @storage_var
    func Zaros_spot_exchange() -> (res: address) {
    }

    // Read functions

    func debt_total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: Uint256
    ) {
        let (res: Uint256) = ERC20.total_supply();

        return (res,);
    }

    func accumulated_fees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: Uint256
    ) {
        let (res: Uint256) = Zaros_accumulated_fees();

        return (res,);
    }

    func protocol_debt_usd{syscall_ptr: felt, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: Uint256
    ) {
    }

    func spot_exchange{syscall_ptr: felt, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: address
    ) {
        let (res) = Zaros_spot_exchange();

        return (res,);
    }

    func debt_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address
    ) -> (res: felt) {
        let (res: Uint256) = ERC20.balance_of(user);

        return (res,);
    }

    // Write functions

    // only registered exchanges
    func mint_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address, amount: Uint256
    ) {
        _only_spot_exchange();

        ERC20._mint(to, amount);
    }

    // only registered exchanges
    func burn_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address, amount: Uint256
    ) {
        _only_spot_exchange();
    }

    // only registered exchanges
    func update_fees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        fee: Uint256
    ) {
        _only_spot_exchange();
    }

    // only registered exchanges
    func _only_spot_exchange{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: address
    ) {
        let (spot_exchange) = spot_exchange();
        with_attr error("Zaros: {caller} is not the spot exchange") {
            assert caller = spot_exchange;
        }

        return ();
    }
}
