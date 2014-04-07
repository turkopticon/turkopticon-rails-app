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
include "mysqli-dbconn.php";

if( !$conn ) {
    die ("Could not connect: (" . mysqli_connect_error() . ") ");
}

if ( $argv[1] ) {
    // Start timing query
    $start_time = microtime(true);

    $search_for = $argv[1];

    // Use regex to see if searching for requester ID
    $pattern = '/\AA[0-9A-Z]{9,}\z/';
    if (preg_match( $pattern , $search_for ) === 1) {
        $search_attribute = 'reports.amzn_requester_id';
    } else {
        $search_attribute = 'reports.amzn_requester_name';
    }

    $search_with_wildcard = '%' . $search_for . '%';

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
    $query .= " WHERE " . $search_attribute; 
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
    $json_results["query"] = "Searching for " . $search_attribute . " that contains " . $search_for;
    $results_count = mysqli_num_rows( $result );
    $json_results["results_count"] = $results_count;
    $json_results["query_time"] = $query_time;
    $json_results["render_time"] = $render_time;

    echo json_encode( $json_results );

    $logfile = '/home/ssilberman/src/turkopticon/php_api/log/search.php.log';
    $time = date('Y-m-j H:i:s');
    $ip = $_SERVER['REMOTE_ADDR'];
    $rounded_query_time = round($query_time, 5);
    file_put_contents($logfile, "[$time]", FILE_APPEND);
    file_put_contents($logfile, "[$ip] ", FILE_APPEND);
    file_put_contents($logfile, "Search for $search_attribute containing '$search_for' ", FILE_APPEND);
    file_put_contents($logfile, "  Returned $results_count results in $rounded_query_time s\n", FILE_APPEND);

} else {
    echo "<p>Put some parameters to start searching!</p>";
}

?>
