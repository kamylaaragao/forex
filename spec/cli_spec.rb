require 'pty' # source: https://www.toasterlovin.com/using-the-pty-class-to-test-interactive-cli-apps-in-ruby/

def read_nth_line(stdout, n)
  (n - 1).times { stdout.gets }
  stdout.gets
end

def user_input(stdout, stdin, input)
  stdin.puts input
  read_nth_line(stdout, 2)
end

RSpec.describe 'command line interface integration test' do
  context 'buying dollars' do
    PTY.spawn('./cli') do |stdout, stdin|
      response = read_nth_line(stdout, 2)

      it 'prompts cashier for the daily fx rate' do
        expect(response).to include 'Cotação do dólar em reais'
        response = user_input(stdout, stdin, '3.2')
      end

      it 'prompts cashier for the USD balance' do
        expect(response).to include 'Dolares disponíveis no caixa'
        response = user_input(stdout, stdin, '100')
      end

      it 'prompts cashier for the BRL balance' do
        expect(response).to include 'Reais disponíveis no caixa'
        response = user_input(stdout, stdin, '400')
      end

      it 'provides cashier a numbered menu of choices' do
        expect(response).to include 'Escolha uma opção no menu'
        read_nth_line(stdout, 7)
      end

      it 'cashier chooses option 1, buying USD' do
        response = user_input(stdout, stdin, '1')
        expect(response).to include 'Opção escolhida: 1'
      end

      it 'cashier provides the number of USD to buy' do
        response = read_nth_line(stdout, 1)
        expect(response).to include 'informe o valor da transação'
        response = user_input(stdout, stdin, '5')
        expect(response).to include 'BRL 16'
      end

      it 'cashier confirms the operation' do
        response = read_nth_line(stdout, 1)
        expect(response).to include 'deseja confirmar a operação? [s/n]'
        response = user_input(stdout, stdin, 's')
        expect(response).to include 'operacao confirmada!'
      end
    end
  end
end
