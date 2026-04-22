function sync-clients
pushd .
~/clients/
source venv/bin/activate.fish
python3 config.py
deactivate
popd
end
