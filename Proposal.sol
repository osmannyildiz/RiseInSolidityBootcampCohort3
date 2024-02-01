// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ProposalContract {
    struct Proposal {
        string title;
        string description;
        uint256 approve_count;
        uint256 reject_count;
        uint256 pass_count;
        uint256 total_vote_count_to_end;
        bool current_state; // whether it passes of fails
        bool is_active;
    }

    mapping(uint256 => Proposal) proposals;
    uint256 private proposal_counter;

    function createProposal(string calldata _title, string calldata _description, uint256 _total_vote_count_to_end) external {
        proposal_counter += 1;
        proposals[proposal_counter] = Proposal(_title, _description, 0, 0, 0, _total_vote_count_to_end, false, true);
    }
}
