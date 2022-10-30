// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.bool import TRUE, FALSE
from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.starknet.common.syscalls import get_caller_address, get_contract_address
from contracts.vaults.IVaultsManager import Vault
from contracts.zaros.IZaros import IZaros, Collateral
from contracts.utils.IERC20 import IERC20
from contracts.oracle.eth.IETHOracle import IETHOracle

using address = felt;

@storage_var
func VaultsManager_zaros() -> (res: address) {
}

@storage_var
func VaultsManager_vaults_len() -> (res: felt) {
}

@storage_var
func VaultsManager_vaults(user: address) -> (res: Vault) {
}

namespace VaultsManager {
    func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        zaros: address
    ) {
        VaultsManager_zaros.write(zaros);

        return ();
    }

    func create_vault{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        eth_amount: Uint256, dai_amount: Uint256, usdc_amount: Uint256, zusd_to_mint: Uint256
    ) {
        alloc_locals;
        let (caller: address) = get_caller_address();
        _verify_caller(caller);
        let (zaros) = VaultsManager_zaros.read();

        // let (first_sum) = SafeUint256.add(eth_amount_usd, dai_amount);
        // let (final_sum) = SafeUint256.add(first_sum, usdc_amount);

        let vault: Vault = Vault(eth_amount, dai_amount, usdc_amount, zusd_to_mint);
        VaultsManager_vaults.write(caller, vault);
        let (vaults_len) = VaultsManager_vaults_len.read();
        VaultsManager_vaults_len.write(vaults_len + 1);
        let (zusd) = IZaros.zusd(contract_address=zaros);

        let (eth: address) = IZaros.collateralTokens(contract_address=zaros, index=0);
        let (dai: address) = IZaros.collateralTokens(contract_address=zaros, index=1);
        let (usdc: address) = IZaros.collateralTokens(contract_address=zaros, index=2);
        let (this_contract) = get_contract_address();

        IERC20.transferFrom(
            contract_address=eth, sender=caller, recipient=this_contract, amount=eth_amount
        );
        IERC20.transferFrom(
            contract_address=dai, sender=caller, recipient=this_contract, amount=dai_amount
        );
        IERC20.transferFrom(
            contract_address=usdc, sender=caller, recipient=this_contract, amount=usdc_amount
        );
        IERC20.mint(contract_address=zusd, to=caller, amount=zusd_to_mint);

        return ();
    }

    func read_vault{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        user: address
    ) -> (res: Vault) {
        let (res: Vault) = VaultsManager_vaults.read(user);

        return (res,);
    }

    func _verify_caller(caller: address) {
        with_attr error_message("Zaros: caller is address 0") {
            assert_not_zero(caller);
        }

        return ();
    }
}
