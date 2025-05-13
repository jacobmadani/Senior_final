// Edge Function: delete-user (index.ts)
import { serve } from "https://deno.land/std@0.182.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.14.0";
import { corsHeaders } from "../_shared/cors.ts";

console.log("Delete user Edge Function started");

serve(async (request) => {
  // Handle OPTIONS request for CORS
  if (request.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Log request details for debugging
    console.log(`Received ${request.method} request`);
    console.log("Request headers:", Object.fromEntries(request.headers.entries()));
    
    // Parse the request body
    let requestData;
    try {
      requestData = await request.json();
      console.log("Request body parsed:", JSON.stringify(requestData));
    } catch (e) {
      console.error("Failed to parse request body:", e);
      throw new Error(`Invalid JSON in request body: ${e.message}`);
    }
    
    // Extract and validate user_id
    const userId = requestData?.user_id;
    if (!userId) {
      console.error("Missing user_id in request:", JSON.stringify(requestData));
      throw new Error("No user_id provided in request body");
    }
    
    console.log(`Attempting to delete user with ID: ${userId}`);

    // Initialize Supabase client with admin privileges using service role key
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    );
    
    if (!supabaseAdmin) {
      throw new Error("Failed to initialize Supabase admin client");
    }

    // Delete the user from Supabase Auth
    console.log(`Calling auth.admin.deleteUser with ID: ${userId}`);
    const { data, error } = await supabaseAdmin.auth.admin.deleteUser(userId);

    // Check for errors during deletion
    if (error) {
      console.error("Error from Supabase auth.admin.deleteUser:", error);
      throw error;
    }

    console.log("User deleted successfully from auth system. Response data:", data);

    // Return success response
    return new Response(
      JSON.stringify({ 
        success: true, 
        message: `User ${userId} deleted successfully from auth system`,
        data: data 
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      },
    );
  } catch (error) {
    // Format error for response
    const errorMessage = error instanceof Error ? error.message : String(error);
    console.error(`Error in delete-user function: ${errorMessage}`);
    
    // Return error response
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: errorMessage,
        details: error instanceof Error ? error.stack : null
      }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      },
    );
  }
});