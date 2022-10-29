%lang starknet

from contracts.utils.constants.library import address

@contract_interface
namespace IZaros {
    func debtTotalSupply() -> (res: felt) {
    }

    func accumulatedFees() -> (res: felt) {
    }

    func protocolDebtUsd() -> (res: felt) {
    }

    func spotExchange() -> (res: felt) {
    }

    func debtShares(user: address) -> (res: felt) {
    }

    func mintShares(user: address, amount: felt) -> (success: felt) {
    }

    func burnShares(user: address, amount: felt) -> (success: felt) {
    }

    func updateFees(fee: felt) -> (success: felt) {
    }
}
