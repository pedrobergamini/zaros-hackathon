// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from openzeppelin.token.erc20.library import ERC20

using address = felt;

// Storage vars
@storage_var
func Zaros_accumulated_fees() -> (res: Uint256) {
}

@storage_var
func Zaros_spot_exchange() -> (res: address) {
}

@storage_var
func Zaros_vaults_manager() -> (res: address) {
}

namespace Zaros {
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
        let (res: Uint256) = Zaros_accumulated_fees.read();

        return (res,);
    }

    func protocol_debt_usd{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: Uint256
    ) {
        return (Uint256(0, 0),);
    }

    func spot_exchange{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: address
    ) {
        let (res: address) = Zaros_spot_exchange.read();

        return (res,);
    }

    func vaults_manager{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: address
    ) {
        let (res: address) = Zaros_vaults_manager.read();

        return (res,);
    }

    func debt_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address
    ) -> (res: Uint256) {
        let (res: Uint256) = ERC20.balance_of(user);

        return (res,);
    }

    // Write functions

    func mint_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address, amount: Uint256
    ) {
        let (caller: address) = get_caller_address();
        _only_vaults_manager(caller);
        ERC20._mint(user, amount);

        return ();
    }

    func burn_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address, amount: Uint256
    ) {
        let (caller: address) = get_caller_address();
        _only_vaults_manager(caller);
        ERC20._burn(user, amount);

        return ();
    }

    func update_fees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        fee: Uint256
    ) {
        let (caller: address) = get_caller_address();
        _only_spot_exchange(caller);

        return ();
    }

    func _only_vaults_manager{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: address
    ) {
        let (vaults_manager: address) = Zaros.vaults_manager();
        with_attr error_message("Zaros: {caller} is not the spot exchange") {
            assert caller = vaults_manager;
        }

        return ();
    }

    func _only_spot_exchange{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        caller: address
    ) {
        let (spot_exchange: address) = Zaros.spot_exchange();
        with_attr error_message("Zaros: {caller} is not the spot exchange") {
            assert caller = spot_exchange;
        }

        return ();
    }
}
