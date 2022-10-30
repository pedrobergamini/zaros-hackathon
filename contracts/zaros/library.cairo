// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address
from openzeppelin.token.erc20.library import ERC20
from openzeppelin.security.safemath.library import SafeUint256
from contracts.utils.IERC20 import IERC20
from contracts.utils.constants.library import Constants
from contracts.zaros.IZaros import zToken, Collateral
from contracts.oracle.eth.IETHOracle import IETHOracle

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
func Zaros_zusd() -> (res: address) {
}

@storage_var
func Zaros_eth_oracle() -> (res: address) {
}

@storage_var
func Zaros_total_accumulated_fees() -> (res: Uint256) {
}

@storage_var
func Zaros_spot_exchange() -> (res: address) {
}

@storage_var
func Zaros_vaults_manager() -> (res: address) {
}

@storage_var
func Zaros_ztokens(index: felt) -> (res: zToken) {
}

@storage_var
func Zaros_collateral_tokens(index: felt) -> (res: address) {
}

namespace Zaros {
    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        spot_exchange: address,
        zeth: zToken,
        eth_oracle: address,
        zusd: address,
        eth: address,
        dai: address,
        usdc: address,
    ) {
        Zaros_spot_exchange.write(spot_exchange);
        Zaros_ztokens.write(0, zeth);
        Zaros_eth_oracle.write(eth_oracle);
        Zaros_zusd.write(zusd);
        Zaros_collateral_tokens.write(0, eth);
        Zaros_collateral_tokens.write(1, dai);
        Zaros_collateral_tokens.write(2, usdc);

        return ();
    }
    // Read functions

    func zusd{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: address) {
        let (res: address) = Zaros_zusd.read();

        return (res,);
    }

    func eth_oracle{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
        res: address
    ) {
        let (res: address) = Zaros_eth_oracle.read();

        return (res,);
    }

    func zeth{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (res: zToken) {
        let (res: zToken) = Zaros_ztokens.read(0);

        return (res,);
    }

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
        alloc_locals;
        let (zusd: address) = Zaros_zusd.read();
        let (zeth_struct: zToken) = Zaros_ztokens.read(0);
        let zeth: address = zeth_struct.token;
        let (total_zusd_minted: Uint256) = IERC20.totalSupply(contract_address=zusd);
        let (total_zeth_minted: Uint256) = IERC20.totalSupply(contract_address=zeth);
        let (eth_oracle: address) = Zaros_eth_oracle.read();
        let (zeth_usd_value: Uint256) = IETHOracle.quote(
            contract_address=eth_oracle, eth_amount=total_zeth_minted
        );
        let (res: Uint256) = SafeUint256.add(zeth_usd_value, total_zusd_minted);

        return (res,);
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
    func set_vaults_manager{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        vaults_manager: address
    ) {
        Zaros_vaults_manager.write(vaults_manager);

        return ();
    }

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

    func _verify_caller(caller: address) {
        with_attr error_message("Zaros: caller is address 0") {
            assert_not_zero(caller);
        }

        return ();
    }
}
