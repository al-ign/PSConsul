<#
.Synopsis
   Delete Key
.DESCRIPTION
   This endpoint deletes a single key or all keys sharing a prefix.
   Alias: Invoke-ConsulKV-Store-Endpoints-Delete-Key
.NOTES
   API Function Name: KV-Store-Endpoints-Delete-Key
   PS Module Safe Name: Invoke-ConsulKV-Store-Endpoints-Delete-Key
#>
function Remove-ConsulKey {
[CmdletBinding()]
[Alias('Invoke-ConsulKV-Store-Endpoints-Delete-Key')]
Param (
    # Specifies the datacenter to query. This will default to the datacenter of the agent being queried. This is specified as part of the URL as a query parameter, and gives "No path to datacenter" error when dc is invalid.
    [string]$dc,

    # Specifies to delete all keys which have the specified prefix. Without this, only a key with an exact match will be deleted.
    [bool]$recurse,

    # Specifies to use a Check-And-Set operation. This is very useful as a building block for more complex synchronization primitives. Unlike PUT, the index must be greater than 0 for Consul to take any action: a 0 index will not delete the key. If the index is non-zero, the key is only deleted if the index matches the ModifyIndex of that key.
    [int]$cas,

    # Enterprise - Specifies the namespace to query. If not provided, the namespace will be inferred from the request's ACL token, or will default to the default namespace. This is specified as part of the URL as a query parameter. Added in Consul 1.7.0.
    [string]$ns,

    # Authentication token
    [string]$ApiToken,

    # Consul URI
    [Parameter(Mandatory=$true)]
    [string]$ApiUri
    )
    Begin {
    # parameters marked as an API parameters

    $ApiParameters = @('dc', 'recurse', 'cas', 'ns')
    $hashApiParameters = @{}

    foreach ($par in $ApiParameters) {
        if ($PSBoundParameters.psbase.Keys -contains $par) {
            $hashApiParameters.Add($par, $PSBoundParameters[$par])
            }
        }

    # parameters marked as used in query

    $queryParameters = @('dc', 'ns')
    $hashqueryParameters = @{}

    foreach ($par in $queryParameters) {
        if ($PSBoundParameters.psbase.Keys -contains $par) {
            $hashqueryParameters.Add($par, $PSBoundParameters[$par])
            }
        }

    # parameters marked as used in auth

    $authParameters = @('ApiToken', 'ApiUri')
    $hashauthParameters = @{}

    foreach ($par in $authParameters) {
        if ($PSBoundParameters.psbase.Keys -contains $par) {
            $hashauthParameters.Add($par, $PSBoundParameters[$par])
            }
        }

    if ($hashQueryParameters) {
        $Query = $hashQueryParameters.psbase.Keys | % {
            '{0}={1}' -f $_, $hashQueryParameters[$_]
            }
        $Query = '?' + ($query -join '&')
    }

    } # End begin block

    End {
    $splat = @{
        Method = 'DELETE'
        Uri = '{0}/v1/kv/{1}{2}' -f $ApiUri, $Key, $Query
        ContentType = 'application/json; charset=utf-8'
        }

    if ($splat.Method -eq 'PUT') {
        $splat.Add('Body',$Value)
        }
            
    if ($Token) {
        $headers = @{
            'X-Consul-Token' = $token
            }
        $splat.Add('Headers',$headers)
        }

    $irm = Invoke-RestMethod @splat -Verbose
    $irm
    } # End end block


} # End  function

