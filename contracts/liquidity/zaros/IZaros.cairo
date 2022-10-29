%lang starknet

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

    func debtShares(user: felt) -> (res: felt) {
    }

    func mintShares(amount: felt) -> (success: felt) {
    }

    func burnShares(amount: felt) -> (success: felt) {
    }

    func updateFees(fee: felt) -> (success: felt) {
    }
}
