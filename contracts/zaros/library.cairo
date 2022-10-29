// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from openzeppelin.token.erc20.library import ERC20
from openzeppelin.security.safemath.library import SafeUint256
from contracts.utils.constants.library import Constants

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
func Zaros_total_accumulated_fees() -> (res: Uint256) {
}

@storage_var
func Zaros_spot_exchange() -> (res: address) {
}

@storage_var
func Zaros_vaults_manager() -> (res: address) {
}

namespace Zaros {
    func initialize{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        spot_exchange: address, vaults_manager: address
    ) {
        with_attr error_message("Zaros: missing initialize input") {
            assert_not_zero(spot_exchange);
            assert_not_zero(vaults_manager);
        }

        Zaros_spot_exchange.write(spot_exchange);
        Zaros_vaults_manager.write(vaults_manager);

        return ();
    }
    // Read functions

    func debt_total_supply{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: Uint256
    ) {
        let (res: Uint256) = ERC20.total_supply();

        return (res,);
    }

    func total_accumulated_fees{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        ) -> (res: Uint256) {
        let (res: Uint256) = Zaros_total_accumulated_fees.read();

        return (res,);
    }

    func accumulated_fees_for{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address
    ) -> (res: Uint256) {
        alloc_locals;
        let (total_accumulated_fees: Uint256) = Zaros.total_accumulated_fees();
        let (total_debt_shares: Uint256) = Zaros.debt_total_supply();
        let (user_debt_shares: Uint256) = Zaros.debt_shares(user);
        let (total_debt_shares_denorm: Uint256) = SafeUint256.mul(
            total_debt_shares, Uint256(Constants.BASE_MULTIPLIER, 0)
        );
        let (fee_per_share_denorm: Uint256, _) = SafeUint256.div_rem(
            total_debt_shares_denorm, total_accumulated_fees
        );

        let (fee_for_user_denorm: Uint256) = SafeUint256.mul(
            fee_per_share_denorm, user_debt_shares
        );
        let (fee_for_user: Uint256, _) = SafeUint256.div_rem(
            fee_for_user_denorm, Uint256(Constants.BASE_MULTIPLIER, 0)
        );

        return (fee_for_user,);
    }

    func zusd_debt_for{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address
    ) -> (res: Uint256) {
        alloc_locals;
        let (protocol_debt_usd: Uint256) = Zaros.protocol_debt_usd();
        let (total_debt_shares: Uint256) = Zaros.debt_total_supply();
        let (user_debt_shares: Uint256) = Zaros.debt_shares(user);
        let (total_debt_shares_denorm: Uint256) = SafeUint256.mul(
            total_debt_shares, Uint256(Constants.BASE_MULTIPLIER, 0)
        );
        let (debt_per_share_denorm: Uint256, _) = SafeUint256.div_rem(
            total_debt_shares_denorm, protocol_debt_usd
        );

        let (debt_for_user_denorm: Uint256) = SafeUint256.mul(
            debt_per_share_denorm, user_debt_shares
        );
        let (zusd_debt_for_user: Uint256, _) = SafeUint256.div_rem(
            debt_for_user_denorm, Uint256(Constants.BASE_MULTIPLIER, 0)
        );

        return (zusd_debt_for_user,);
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
        let (accumulated_fees_current: Uint256) = Zaros_total_accumulated_fees.read();
        let (accumulated_fees_updated: Uint256) = SafeUint256.add(accumulated_fees_current, fee);
        Zaros_total_accumulated_fees.write(accumulated_fees_updated);

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
