InModuleScope 'Terminal-Icons' {

    Describe 'Add-TerminalIconsColorTheme' {

        Context 'Themes' {

            Mock Export-CliXml {}

            BeforeAll {
                $tmpDir    = [IO.Path]::GetTempPath()
                $themePath = [IO.Path]::Combine($tmpDir, 'MyAwesomeTheme.psd1')
                $script:goodTheme = New-Item -Path $themePath -Force

                $themeContent = @'
@{
    Name  = 'MyAwesomeTheme'
    Types = @{
        Directories = @{
            WellKnown = @{
            }
        }
        Files       = @{
            WellKnown = @{
            }
        }
    }
}
'@
            $themeContent  | Out-File $goodTheme -Encoding utf8
            $goodThemeName = $goodTheme.BaseName
            }

            AfterAll {
                $goodTheme | Remove-Item
            }

            it 'Good theme should be added' {
                Add-TerminalIconsColorTheme -Path $goodTheme.FullName -Force
                $script:themeData.Themes.Color[$goodThemeName]      | Should -BeOfType System.Collections.Hashtable
                $script:themeData.Themes.Color[$goodThemeName].Name | Should -Be 'MyAwesomeTheme'
            }

            it 'Bad theme path should throw' {
                $badThemeFile = [guid]::NewGuid().ToString()
                {Add-TerminalIconsColorTheme -Path "./$badThemeFile" -ErrorAction Stop} | Should -Throw
            }
        }
    }
}
