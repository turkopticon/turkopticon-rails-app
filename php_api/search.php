<?php

/* * * * * * * * * * * * * * * * * *
 search.php
 ===================================
 Jay Tolentino and Six Silberman
 ===================================
 Searches Turkopticon databases for
 information
 * * * * * * * * * * * * * * * * * */

header("Access-Control-Allow-Origin");
include "dbconn.php";

if( !$conn ) {
    die ("Could not connect: (" . mysqli_connect_error() . ") ");
}

if ( $argv[1] && $argv[2] && $argv[3]) {
    // Start timing query
    $start_time = microtime(true);

    $search_for = $argv[1]; //query
    $search_field = $argv[2]; //field
    $search_type = $argv[3]; //type

    // Types of search field:
    // - NAME : search through requester names
    // -   ID : search through amzn requester ids
    switch ($search_field) { 
        case "name":
            $search_attribute = "reports.amzn_requester_name";
            break;
        case "id" :
            $search_attribute = "reports.amzn_requester_id";
            break;
        default : // TODO does this ensure security of $search_attribute?
            break;
    }


    // Types of search types:
    // - CONTAIN : contains the query string
    // -   START : starts with query string
    // -     END : ends with query string
    // -   EXACT : looks for exact match to search query
    switch ($search_type) {
        case "contain":
            $search_with_wildcard = "%{$search_for}%";
            break;
        case "start":
            $search_with_wildcard = "{$search_for}%";
            break;
        case "end":
            $search_with_wildcard = "%{$search_for}";
            break;
        case "exact":
            $search_with_wildcard = "{$search_for}";
    }

    // Create and execute a prepared statement
    $stmt = mysqli_stmt_init( $conn );

    $query = "SELECT reports.amzn_requester_id,
                     reports.amzn_requester_name,
                     reports.id AS to_report_id,
                     reports.fair,
                     reports.fast,
                     reports.pay,
                     reports.comm,
                     reports.description AS text,
                     reports.person_id AS reviewer_id,
                     reports.created_at,
                     reports.tos_viol,
                     reports.displayed_notes,
                     reports.is_flagged,
                     reports.is_hidden,
                     reports.flag_count,
                     reports.comment_count,
                     people.id,
                     people.display_name";
    $query .= " FROM people, reports";
    $query .= " WHERE " . $search_attribute; // TODO secure usage of $search_attribute?
    $query .= " LIKE ?";
    $query .= " AND reports.amzn_requester_id IS NOT NULL";
    $query .= " AND reports.amzn_requester_name IS NOT NULL";
    $query .= " AND people.id = reports.person_id";
    $query .= " ORDER BY reports.amzn_requester_name, to_report_id DESC";

    if ( mysqli_stmt_prepare( $stmt, $query ) ) {
        mysqli_stmt_bind_param( $stmt, 's', $search_with_wildcard );

        mysqli_stmt_execute( $stmt );
        $result = mysqli_stmt_get_result( $stmt );

        $all_reviews = array();

        // Record query timing, start render timing
        $query_time = (microtime(true) - $start_time);
        $start_render_time = microtime(true);

        if ( mysqli_num_rows( $result ) != 0 ) {
            while( $row = mysqli_fetch_assoc( $result ) ) {
                array_push($all_reviews, $row);
            }
        }
    }

    // Record rendering time
    $render_time = ( (microtime(true)) - $start_render_time );

    $json_results["reviews"] = $all_reviews;
    $json_results["query"] = "Searching for a " . $search_field . " that " . $search_type . "s " . $search_for;
    $json_results["results_count"] = mysqli_num_rows( $result );
    $json_results["query_time"] = $query_time;
    $json_results["render_time"] = $render_time;

    echo json_encode( $json_results );
    //var_dump($json_results);

} else {
    echo "<p>Put some parameters to start searching!</p>";
}
