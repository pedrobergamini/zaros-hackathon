// SPDX-License-Identifier: MIT
%lang starknet

from starkware.cairo.common.builtins import HashBuiltin
from contracts.oracle.empiric.IEmpiric import IEmpiric
from contracts.utils.constants.library import EMPIRIC_ORACLE_ADDRESS, PAIR_ID

@view
func my_func{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> () {
    let (
        eth_price, decimals, last_updated_timestamp, num_sources_aggregated
    ) = IEmpiric.get_spot_median(EMPIRIC_ORACLE_ADDRESS, PAIR_ID);

    return ();
}
