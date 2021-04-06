<#
.Synopsis
   Read Key
.DESCRIPTION
   This endpoint returns the specified key. If no key exists at the given path, a
   404 is returned instead of a 200 response.
   Alias: Invoke-ConsulKV-Store-Endpoints-Read-Key
.NOTES
   API Function Name: KV-Store-Endpoints-Read-Key
   PS Module Safe Name: Invoke-ConsulKV-Store-Endpoints-Read-Key
#>
function Get-ConsulKey {
[CmdletBinding()]
[Alias('Invoke-ConsulKV-Store-Endpoints-Read-Key')]
Param (
    # Specifies the path of the key to read.
    [string]$key,

    # Specifies the datacenter to query. This will default to the datacenter of the agent being queried. This is specified as part of the URL as a query parameter.
    [string]$dc,

    # Specifies if the lookup should be recursive and key treated as a prefix instead of a literal match. This is specified as part of the URL as a query parameter.
    [switch]$recurse,

    # Specifies the response is just the raw value of the key, without any encoding or metadata. This is specified as part of the URL as a query parameter.
    [switch]$raw,

    # Specifies to return only keys (no values or metadata). Specifying this implies recurse. This is specified as part of the URL as a query parameter.
    [switch]$keys,

    # Specifies the string to use as a separator for recursive key lookups. This option is only used when paired with the keys parameter to limit the prefix of keys returned, only up to the given separator. This is specified as part of the URL as a query parameter.
    [string]$separator,

    # Enterprise - Specifies the namespace to query. If not provided, the namespace will be inferred from the request's ACL token, or will default to the default namespace. This is specified as part of the This is specified as part of the URL as a query parameter. For recursive lookups, the namespace may be specified as '*' and then results will be returned for all namespaces. Added in Consul 1.7.0.
    [string]$ns,

    # Authentication token
    [string]$ApiToken,

    # Consul URI
    [Parameter(Mandatory=$true)]
    [string]$ApiUri
    )
    Begin {
    # parameters marked as an API parameters

    $ApiParameters = @('key', 'dc', 'recurse', 'raw', 'keys', 'separator', 'ns')
    $hashApiParameters = @{}

    foreach ($par in $ApiParameters) {
        if ($PSBoundParameters.psbase.Keys -contains $par) {
            $hashApiParameters.Add($par, $PSBoundParameters[$par])
            }
        }

    # parameters marked as used in query

    $queryParameters = @('dc', 'recurse', 'raw', 'keys', 'separator', 'ns')
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

    class ConsulKey {
        [int]$CreateIndex
        [int]$Flags
        [string]$Key
        [int]$LockIndex
        [int]$ModifyIndex
        [string]$Value

        [string] ToASCII () {
            return [System.Text.Encoding]::ASCII.GetString(
                [System.Convert]::FromBase64String($this.Value)
                )
            }

        [string] ToUnicode () {
            return [System.Text.Encoding]::Unicode.GetString(
                [System.Convert]::FromBase64String($this.Value)
                )
            }

        [string] ToUTF8 () {
            return [System.Text.Encoding]::UTF8.GetString(
                [System.Convert]::FromBase64String($this.Value)
                )
            }

        }
    } # End begin block

    End {
    $splat = @{
        Method = 'GET'
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
        #map to the class if not recurse
        if ($PSBoundParameters.psbase.Keys -match 'keys|recurse|raw') {
            $irm
            }
        else {
            foreach ($thisResponse in $irm) {
                [ConsulKey]$thisResponse
                }
            }
    } # End end block


} # End  function

