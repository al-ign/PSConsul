<#
.Synopsis
   Create/Update Key
.DESCRIPTION
   This endpoint updates the value of the specified key. If no key exists at the given
   path, the key will be created.
   Alias: Invoke-ConsulKV-Store-Endpoints-Create-Update-Key, New-ConsulKey
.NOTES
   API Function Name: KV-Store-Endpoints-Create-Update-Key
   PS Module Safe Name: Invoke-ConsulKV-Store-Endpoints-Create-Update-Key
#>
function Set-ConsulKey {
[CmdletBinding()]
[Alias('Invoke-ConsulKV-Store-Endpoints-Create-Update-Key', 'New-ConsulKey')]
Param (
    # Specifies the path of the key.
    [string]$key,

    # Specifies the datacenter to query. This will default to the datacenter of the agent being queried. This is specified as part of the URL as a query parameter.
    [string]$dc,

    # Specifies an unsigned value between 0 and (2^64)-1. Clients can choose to use this however makes sense for their application. This is specified as part of the URL as a query parameter.
    [int]$flags,

    # Specifies to use a Check-And-Set operation. This is very useful as a building block for more complex synchronization primitives. If the index is 0, Consul will only put the key if it does not already exist. If the index is non-zero, the key is only set if the index matches the ModifyIndex of that key.
    [int]$cas,

    # Supply a session ID to use in a lock acquisition operation. This is useful as it allows leader election to be built on top of Consul. If the lock is not held and the session is valid, this increments the LockIndex and sets the Session value of the key in addition to updating the key contents. A key does not need to exist to be acquired. If the lock is already held by the given session, then the LockIndex is not incremented but the key contents are updated. This lets the current lock holder update the key contents without having to give up the lock and reacquire it. Note that an update that does not include the acquire parameter will proceed normally even if another session has locked the key.For an example of how to use the lock feature, check the Leader Election tutorial.
    [string]$acquire,

    # Supply a session ID to use in a release operation. This is useful when paired with ?acquire= as it allows clients to yield a lock. This will leave the LockIndex unmodified but will clear the associated Session of the key. The key must be held by this session to be unlocked.
    [string]$release,

    # Enterprise - Specifies the namespace to query. If not provided, the namespace will be inferred from the request's ACL token, or will default to the default namespace. This is specified as part of the URL as a query parameter. Added in Consul 1.7.0.
    [string]$ns,

    # Authentication token
    [string]$ApiToken,

    # Consul URI
    [Parameter(Mandatory=$true)]
    [string]$ApiUri,

    # Key Value
    $Value,

    # Content type to use
    [string]$ContentType = 'application/json; charset=utf-8'
    )
    Begin {
    # parameters marked as an API parameters

    $ApiParameters = @('key', 'dc', 'flags', 'cas', 'acquire', 'release', 'ns', 'Value')
    $hashApiParameters = @{}

    foreach ($par in $ApiParameters) {
        if ($PSBoundParameters.psbase.Keys -contains $par) {
            $hashApiParameters.Add($par, $PSBoundParameters[$par])
            }
        }

    # parameters marked as used in query

    $queryParameters = @('dc', 'flags', 'ns')
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

    # parameters marked as used in body

    $bodyParameters = @('Value')
    $hashbodyParameters = @{}

    foreach ($par in $bodyParameters) {
        if ($PSBoundParameters.psbase.Keys -contains $par) {
            $hashbodyParameters.Add($par, $PSBoundParameters[$par])
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
        Method = 'PUT'
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

