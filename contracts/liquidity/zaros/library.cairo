// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from openzeppelin.token.erc20.library import ERC20
from openzeppelin.security.safemath.library import SafeUint256

using address = felt;

// Events
@event
func LogMintShare(user: address, amount: Uint256) {
}

@event
func LogBurnShare(user: address, amount: Uint256) {
}

@event
func LogUpdateFees(fee: Uint256, accumulated_fees: Uint256) {
}

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

        LogMintShare.emit(user, amount);

        return ();
    }

    func burn_shares{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address, amount: Uint256
    ) {
        let (caller: address) = get_caller_address();
        _only_vaults_manager(caller);
        ERC20._burn(user, amount);

        LogBurnShare.emit(user, amount);

        return ();
    }

    func update_fees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        fee: Uint256
    ) {
        let (caller: address) = get_caller_address();
        _only_spot_exchange(caller);
        let (accumulated_fees_current: Uint256) = Zaros_accumulated_fees.read();
        let (accumulated_fees_updated: Uint256) = SafeUint256.add(accumulated_fees_current, fee);
        Zaros_accumulated_fees.write(accumulated_fees_updated);

        LogUpdateFees.emit(fee, accumulated_fees_updated);
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
