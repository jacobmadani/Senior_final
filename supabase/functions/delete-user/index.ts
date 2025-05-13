import { serve } from "https://deno.land/std/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js";

// Start server to handle the DELETE request
serve(async (req) => {
  try {
    // Parse JSON body to extract the user_id
    const { user_id } = await req.json();

    // Create a Supabase client using the environment variables
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!, // Ensure your SUPABASE_URL is set in the environment
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")! // Ensure your SUPABASE_SERVICE_ROLE_KEY is set in the environment
    );

    // Call the Supabase deleteUser method to remove the user
    const { error } = await supabase.auth.admin.deleteUser(user_id);

    // If an error occurs, return an error response
    if (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
      });
    }

    // Return a success response if user deletion was successful
    return new Response(
      JSON.stringify({ message: "User deleted successfully" }),
      { status: 200 }
    );
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : String(error);

    console.error("🔥 Unexpected error:", errorMessage);

    return new Response(JSON.stringify({ error: errorMessage }), {
      status: 500,
    });
  }
});
