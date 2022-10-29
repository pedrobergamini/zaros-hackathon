// SPDX-License-Identifier: MIT
%lang starknet

using address = felt;
using bool = felt;

struct zToken {
    token: address,
    price_feed: address,
}

struct Collateral {
    token: address,
    is_usd: bool,
}

@contract_interface
namespace IZaros {
    func zusd() -> (res: address) {
    }

    func eth_oracle() -> (res: address) {
    }

    func debtTotalSupply() -> (res: felt) {
    }

    func totalAccumulatedFees() -> (res: felt) {
    }

    func protocolDebtUsd() -> (res: felt) {
    }

    func spotExchange() -> (res: felt) {
    }

    func debtShares(user: address) -> (res: felt) {
    }

    func ztokens(index: felt) -> (res: address) {
    }

    func collateralTokens(index: felt) -> (res: address) {
    }

    func accumulatedFeesFor(user: address) -> (res: felt) {
    }

    func zusdDebtFor(user: address) -> (res: felt) {
    }

    func setVaultsManager(vaults_manager: address) {
    }

    func mintShares(user: address, amount: felt) -> (success: bool) {
    }

    func burnShares(user: address, amount: felt) -> (success: bool) {
    }

    func updateFees(fee: felt) -> (success: bool) {
    }
}
