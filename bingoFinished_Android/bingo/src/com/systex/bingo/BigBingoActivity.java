package com.systex.bingo;

import java.util.Random;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.NumberPicker;
import android.widget.SeekBar;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;

public class BigBingoActivity extends Activity {

	Button[] btns = null;

	Button btnRandom = null, btnInit = null;
	TextView tvLines = null;
	Switch gameModeSwitch = null;
	Boolean currentGameMode = false;
	ImageView imgBingo = null;

	View.OnClickListener shortClickListener = null;
	View.OnLongClickListener longClickListener = null;

	char[][] gameState = new char[5][5];

	int randomRange = 30;
	int currentLines = 0;

	int randomNumArray[] = null;

	int seekBarTempProgress = 30;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_bigbingo);

		init();

	}

	public void init() {

		tvLines = (TextView) findViewById(R.id.BtextView1);
		tvLines.setText(getString(R.string.lines) + ":"

		+ ((Integer) currentLines).toString());

		gameModeSwitch = (Switch) findViewById(R.id.BSwitch1);

		gameModeSwitch
				.setOnCheckedChangeListener(new OnCheckedChangeListener() {

					@Override
					public void onCheckedChanged(CompoundButton buttonView,
					boolean isChecked) {
						
						
						if (true == isChecked) {
							
							currentGameMode = true;
							
							for(int i=0;i<25;i++){
								
						          if(getString(R.string.input)==btns[i].getText())
						          {
						        	
						        	  gameModeSwitch.setChecked(false);
						        	  currentGameMode = false;
						        	  
						        Toast.makeText(getApplicationContext(),
						        		R.string.notYet,Toast.LENGTH_SHORT ).show();	  
						        	  break;
						        	  
						          }
								
							}
							
							
							
						} else
							currentGameMode = false;

					}

				});

		imgBingo = (ImageView) findViewById(R.id.BimgBingo);

		btns = new Button[25];

		btns[0] = (Button) findViewById(R.id.BButton01);
		btns[1] = (Button) findViewById(R.id.BButton02);
		btns[2] = (Button) findViewById(R.id.BButton03);
		btns[3] = (Button) findViewById(R.id.BButton04);
		btns[4] = (Button) findViewById(R.id.BButton05);
		btns[5] = (Button) findViewById(R.id.BButton06);
		btns[6] = (Button) findViewById(R.id.BButton07);
		btns[7] = (Button) findViewById(R.id.BButton08);
		btns[8] = (Button) findViewById(R.id.BButton09);
		btns[9] = (Button) findViewById(R.id.BButton10);
		btns[10] = (Button) findViewById(R.id.BButton11);
		btns[11] = (Button) findViewById(R.id.BButton12);
		btns[12] = (Button) findViewById(R.id.BButton13);
		btns[13] = (Button) findViewById(R.id.BButton14);
		btns[14] = (Button) findViewById(R.id.BButton15);
		btns[15] = (Button) findViewById(R.id.BButton16);
		btns[16] = (Button) findViewById(R.id.BButton17);
		btns[17] = (Button) findViewById(R.id.BButton18);
		btns[18] = (Button) findViewById(R.id.BButton19);
		btns[19] = (Button) findViewById(R.id.BButton20);
		btns[20] = (Button) findViewById(R.id.BButton21);
		btns[21] = (Button) findViewById(R.id.BButton22);
		btns[22] = (Button) findViewById(R.id.BButton23);
		btns[23] = (Button) findViewById(R.id.BButton24);
		btns[24] = (Button) findViewById(R.id.BButton25);

		btnRandom = (Button) findViewById(R.id.BButtonRandom);
		btnInit = (Button) findViewById(R.id.BButtonInit);

		// 短按監聽
		shortClickListener = new View.OnClickListener() {

			@Override
			public void onClick(View v) {

				if (false == currentGameMode) {} //輸入模式時不能玩遊戲
				else
				{

					Button m_pressedButton = (Button) v;

					int indexOfPressedButton = Integer.parseInt(m_pressedButton
							.getTag().toString());

					int row = indexOfPressedButton / 5;
					int col = indexOfPressedButton % 5;

					if ('G' == gameState[row][col]) {

						gameState[row][col] = 'R';
						m_pressedButton.setBackgroundColor(Color.RED);

					}

					else {
						gameState[row][col] = 'G';
						m_pressedButton.setBackgroundColor(Color.GREEN);

					}

					// Toast.makeText(getApplicationContext(),
					// ((Integer)checkLines()).toString(),
					// Toast.LENGTH_SHORT).show();

					currentLines = checkLines();

					tvLines.setText(getString(R.string.lines) + ":"
							+ ((Integer) currentLines).toString());

					if (currentLines >= 5)
					{
						imgBingo.setVisibility(1); // 1為VISIBLE
						
					}
					else
						imgBingo.setVisibility(8); // 8為GONE(不佔位置)

				}
			}

		};

		// 長按監聽

		longClickListener = new View.OnLongClickListener() {

			@Override
			public boolean onLongClick(View v) {
				
			if (true == currentGameMode) {} //遊戲模式時不可輸入數字
			else
			  {

				Button m_pressedButton = (Button) v;

				showNumPickerDialog(m_pressedButton);
				
			  }
				return true;
			  
			}
		};

		for (int i = 0; i < 25; i++) {

			btns[i].setTag(i);
			btns[i].setOnClickListener(shortClickListener);
			btns[i].setOnLongClickListener(longClickListener);

			gameState[i / 5][i % 5] = 'G';
		}

		// 按下亂數鈕時
		btnRandom.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
			if (true == currentGameMode) {} //遊戲模式時無法按下亂數鈕
			
			else 	{showRandomNumDialog();}

			}
		});

		// 按下初始化鈕
		btnInit.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				
				gameModeSwitch.setChecked(false);
				currentGameMode=false;
				
				currentLines = 0;
				tvLines.setText(getString(R.string.lines) + ":"
						+ ((Integer) currentLines).toString());

				randomRange = 30;
				seekBarTempProgress = 30;

				imgBingo.setVisibility(8);

				for (int i = 0; i < 25; i++) {

					btns[i].setText(R.string.input);
					btns[i].setBackgroundColor(Color.GREEN);
					gameState[i / 5][i % 5] = 'G';

				}

			}
		});

	}

	// ====================================================================

	// 算目前連線數

	public int checkLines() {

		int countLines = 0;

		// 算橫連線
		for (int i = 0; i < 5; i++) {
			Boolean isLine = true;

			for (int j = 0; j < 5; j++) {

				if ('G' == gameState[i][j]) {
					isLine = false;
					break;

				}

			}

			if (true == isLine)
				countLines++;

		}

		// 算直連線
		for (int i = 0; i < 5; i++) {
			Boolean isLine = true;

			for (int j = 0; j < 5; j++) {

				if ('G' == gameState[j][i]) {
					isLine = false;
					break;

				}

			}

			if (true == isLine)
				countLines++;

		}

		// 算斜線連線(左上至右下)

		Boolean isSlashLine_1 = true;

		for (int i = 0; i < 5; i++) {

			if ('G' == gameState[i][i]) {
				isSlashLine_1 = false;
				break;

			}

		}

		if (true == isSlashLine_1)
			countLines++;

		// 算斜線連線(右上至左下)

		Boolean isSlashLine_2 = true;

		for (int i = 0; i < 5; i++) {

			if ('G' == gameState[i][4 - i]) {
				isSlashLine_2 = false;
				break;

			}

		}

		if (true == isSlashLine_2)
			countLines++;

		return countLines;

	}

	public void showNumPickerDialog(final Button m_pressedButton) {

		final Dialog d = new Dialog(this);
		d.setTitle(R.string.numPicker);
		d.setContentView(R.layout.num_plcker_dialog);
		Button m_btnComfirm = (Button) d.findViewById(R.id.buttonComfirm);
		Button m_btnCancel = (Button) d.findViewById(R.id.buttonCancel);
		final NumberPicker np = (NumberPicker) d
				.findViewById(R.id.numberPicker1);
		np.setMaxValue(50);
		np.setMinValue(1);
		np.setWrapSelectorWheel(true);

		m_btnComfirm.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {

				Boolean m_isRepeat = false;
				for (int i = 0; i < 25; i++) {

					if (String.valueOf(np.getValue()) == btns[i].getText())
						m_isRepeat = true;

				}

				if (true == m_isRepeat) {
					Toast.makeText(getApplicationContext(), R.string.isRepeat,
							Toast.LENGTH_SHORT).show();
				} else {

					m_pressedButton.setText(String.valueOf(np.getValue()));
					d.dismiss();
				}
			}
		});
		m_btnCancel.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				d.dismiss();
			}
		});
		d.show();

	}

	// 數值範圍dialog
	public void showRandomNumDialog()

	{

		final AlertDialog.Builder popDialog = new AlertDialog.Builder(this);
		LayoutInflater inflater = LayoutInflater.from(this);
		final View seekView = inflater.inflate(R.layout.seek_bar_view, null);
		final SeekBar seek = (SeekBar) seekView
				.findViewById(R.id.seekBarPenSize);
		final TextView txtSeek = (TextView) seekView
				.findViewById(R.id.textViewSeekBar);

		seek.setMax(25);

		seek.setProgress(seekBarTempProgress - 25);

		popDialog.setTitle(getString(R.string.selectmaxrange) + "25~50");

		txtSeek.setText(getString(R.string.maxrange) + (seekBarTempProgress));

		popDialog.setView(seekView);

		seek.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {

				txtSeek.setText(getString(R.string.maxrange) + (progress + 25));

				seekBarTempProgress = progress + 25;

			}

			@Override
			public void onStartTrackingTouch(SeekBar seekBar) {

			}

			@Override
			public void onStopTrackingTouch(SeekBar seekBar) {

			}

		});

		// 按下確認時

		popDialog.setPositiveButton(R.string.comfirm,

		new DialogInterface.OnClickListener() {

			public void onClick(DialogInterface dialog, int which) {

				// 設定亂數最大範圍
				randomRange = seekBarTempProgress;
				// 取亂數
				getRandomNum();

				for (int i = 0; i < 25; i++) {

					btns[i].setText(((Integer) (randomNumArray[i])).toString());

				}
				dialog.dismiss();
			}
		});

		// 按下取消時關閉dialog
		popDialog.setNegativeButton(R.string.cancel,

		new DialogInterface.OnClickListener() {

			public void onClick(DialogInterface dialog, int which) {

				dialog.dismiss();
			}
		});

		popDialog.create();
		popDialog.show();

	}

	// 取得亂數陣列
	public void getRandomNum() {

		randomNumArray = new int[randomRange];

		Random rd = new Random();
		for (int i = 0; i < randomNumArray.length; i++) {
			randomNumArray[i] = i + 1;
		}

		int j, x;

		for (int i = 0; i < randomNumArray.length; i++) {
			j = rd.nextInt(randomNumArray.length);
			x = randomNumArray[i];
			randomNumArray[i] = randomNumArray[j];
			randomNumArray[j] = x;
		}

	}

}
