# Supabase setup for Forma

1. Create a Supabase project and run `supabase/schema.sql` in its SQL Editor.
2. In the Vercel project settings, add `SUPABASE_URL` and `SUPABASE_ANON_KEY` for Production and Preview deployments. Use the project's public anon/publishable key; never put a service-role key in browser code.
3. Redeploy. `/api/config` supplies the public connection settings; Supabase Auth handles passwords and email confirmation, and Row Level Security restricts project rows to their owner.
4. In Supabase Auth settings, set the site URL and allowed redirect URLs to the deployed Forma domain (and localhost for local testing).

Without these environment variables the editor stays usable in local demo mode, but real accounts and cloud project sync are unavailable.
