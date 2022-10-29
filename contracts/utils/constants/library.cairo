// SPDX-License-Identifier: MIT
%lang starknet

namespace Constants {
    // @dev Empiric deployed oracle address
    const EMPIRIC_ORACLE_ADDRESS = 0x446812bac98c08190dee8967180f4e3cdcd1db9373ca269904acb17f67f7093;
    // @dev ETH/USD pair identifier
    const PAIR_ID = 19514442401534788;  // str_to_felt("ETH/USD")
    // @dev Base rewards calculation multiplier, used for divisions
    const BASE_MULTIPLIER = 10 ** 18;
}
